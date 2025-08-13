#!/bin/bash

# Container Security Scanner for Free GitHub Edition
# This script provides local container scanning capabilities equivalent to GitHub Actions

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default values
IMAGE_NAME="lighttpd-alpine:test"
DOCKERFILE_PATH="."
OUTPUT_DIR="./scan-results"
SCAN_FORMAT="table"
SEVERITY_LEVELS="CRITICAL,HIGH,MEDIUM"

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install Trivy
install_trivy() {
    print_status "Installing Trivy..."
    
    if command_exists trivy; then
        print_success "Trivy is already installed"
        return 0
    fi
    
    # Detect OS and architecture
    OS=$(uname -s | tr '[:upper:]' '[:lower:]')
    ARCH=$(uname -m)
    
    case $ARCH in
        x86_64) ARCH="amd64" ;;
        aarch64) ARCH="arm64" ;;
        armv7l) ARCH="armv7" ;;
    esac
    
    # Install Trivy
    if [ "$OS" = "linux" ]; then
        if command_exists wget; then
            wget -qO- https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin
        elif command_exists curl; then
            curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin
        else
            print_error "Neither wget nor curl is available. Please install Trivy manually."
            exit 1
        fi
    elif [ "$OS" = "darwin" ]; then
        if command_exists brew; then
            brew install trivy
        else
            print_error "Homebrew not found. Please install Trivy manually on macOS."
            exit 1
        fi
    else
        print_error "Unsupported operating system: $OS"
        exit 1
    fi
    
    if command_exists trivy; then
        print_success "Trivy installed successfully"
    else
        print_error "Failed to install Trivy"
        exit 1
    fi
}

# Function to build Docker image
build_image() {
    print_status "Building Docker image: $IMAGE_NAME"
    
    if ! command_exists docker; then
        print_error "Docker is not installed or not in PATH"
        exit 1
    fi
    
    if ! docker build -t "$IMAGE_NAME" "$DOCKERFILE_PATH"; then
        print_error "Failed to build Docker image"
        exit 1
    fi
    
    print_success "Docker image built successfully"
}

# Function to run vulnerability scan
run_scan() {
    print_status "Running vulnerability scan..."
    
    # Create output directory
    mkdir -p "$OUTPUT_DIR"
    
    # Run scan with different formats
    print_status "Generating table format report..."
    if ! trivy image --severity "$SEVERITY_LEVELS" --format table "$IMAGE_NAME" | tee "$OUTPUT_DIR/scan-table.txt"; then
        print_error "Failed to generate table format report"
        return 1
    fi
    
    print_status "Generating JSON format report..."
    if ! trivy image --severity "CRITICAL,HIGH,MEDIUM,LOW" --format json --output "$OUTPUT_DIR/scan-results.json" "$IMAGE_NAME"; then
        print_error "Failed to generate JSON format report"
        return 1
    fi
    
    print_status "Generating HTML format report..."
    if ! trivy image --severity "CRITICAL,HIGH,MEDIUM,LOW" --format template --template "@contrib/html.tpl" --output "$OUTPUT_DIR/scan-report.html" "$IMAGE_NAME" 2>/dev/null; then
        print_warning "HTML report generation failed (template not found or network issues)"
    fi
    
    print_success "Vulnerability scan completed"
}

# Function to parse and summarize results
parse_results() {
    print_status "Parsing scan results..."
    
    if [ ! -f "$OUTPUT_DIR/scan-results.json" ]; then
        print_error "JSON scan results not found"
        return 1
    fi
    
    # Check if jq is available
    if ! command_exists jq; then
        print_warning "jq is not installed. Installing it would provide better result parsing."
        print_status "Summary will be based on text output instead."
        
        # Parse from table output
        local critical_count=$(grep -c "CRITICAL" "$OUTPUT_DIR/scan-table.txt" || echo "0")
        local high_count=$(grep -c "HIGH" "$OUTPUT_DIR/scan-table.txt" || echo "0")
        local medium_count=$(grep -c "MEDIUM" "$OUTPUT_DIR/scan-table.txt" || echo "0")
    else
        # Parse with jq
        local critical_count=$(jq '.Results[]?.Vulnerabilities[]? | select(.Severity=="CRITICAL") | .VulnerabilityID' "$OUTPUT_DIR/scan-results.json" 2>/dev/null | wc -l || echo "0")
        local high_count=$(jq '.Results[]?.Vulnerabilities[]? | select(.Severity=="HIGH") | .VulnerabilityID' "$OUTPUT_DIR/scan-results.json" 2>/dev/null | wc -l || echo "0")
        local medium_count=$(jq '.Results[]?.Vulnerabilities[]? | select(.Severity=="MEDIUM") | .VulnerabilityID' "$OUTPUT_DIR/scan-results.json" 2>/dev/null | wc -l || echo "0")
        local low_count=$(jq '.Results[]?.Vulnerabilities[]? | select(.Severity=="LOW") | .VulnerabilityID' "$OUTPUT_DIR/scan-results.json" 2>/dev/null | wc -l || echo "0")
    fi
    
    # Create summary
    {
        echo "# Container Vulnerability Scan Summary"
        echo ""
        echo "Image: $IMAGE_NAME"
        echo "Scan Date: $(date)"
        echo ""
        echo "## Vulnerability Counts"
        echo ""
        echo "| Severity | Count |"
        echo "|----------|-------|"
        echo "| Critical | $critical_count |"
        echo "| High | $high_count |"
        echo "| Medium | $medium_count |"
        [ -n "$low_count" ] && echo "| Low | $low_count |"
        echo ""
        
        if [ "$critical_count" -gt 0 ] || [ "$high_count" -gt 0 ]; then
            echo "❌ **Security scan failed**: Found $critical_count critical and $high_count high severity vulnerabilities"
            echo ""
            echo "**Recommendation**: Review and address critical and high severity vulnerabilities before deployment."
        else
            echo "✅ **Security scan passed**: No critical or high severity vulnerabilities found"
        fi
        
        echo ""
        echo "## Available Reports"
        echo ""
        echo "- Table format: scan-results/scan-table.txt"
        echo "- JSON format: scan-results/scan-results.json"
        [ -f "$OUTPUT_DIR/scan-report.html" ] && echo "- HTML format: scan-results/scan-report.html"
        
    } > "$OUTPUT_DIR/summary.md"
    
    print_success "Scan summary created: $OUTPUT_DIR/summary.md"
    
    # Display summary
    cat "$OUTPUT_DIR/summary.md"
    
    # Return exit code based on results
    if [ "$critical_count" -gt 0 ] || [ "$high_count" -gt 0 ]; then
        return 1
    else
        return 0
    fi
}

# Function to show usage
show_usage() {
    echo "Container Security Scanner for Free GitHub Edition"
    echo ""
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -i, --image IMAGE       Docker image name (default: lighttpd-alpine:test)"
    echo "  -d, --dockerfile PATH   Path to Dockerfile directory (default: .)"
    echo "  -o, --output DIR        Output directory for results (default: ./scan-results)"
    echo "  -s, --severity LEVELS   Comma-separated severity levels (default: CRITICAL,HIGH,MEDIUM)"
    echo "  --install-trivy         Install Trivy automatically"
    echo "  --no-build              Skip Docker image build"
    echo "  -h, --help              Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0                      # Scan with default settings"
    echo "  $0 --install-trivy      # Install Trivy and scan"
    echo "  $0 -i myimage:latest    # Scan specific image"
    echo "  $0 --no-build -i myimage:latest  # Scan existing image without building"
}

# Parse command line arguments
SKIP_BUILD=false
INSTALL_TRIVY=false

while [[ $# -gt 0 ]]; do
    case $1 in
        -i|--image)
            IMAGE_NAME="$2"
            shift 2
            ;;
        -d|--dockerfile)
            DOCKERFILE_PATH="$2"
            shift 2
            ;;
        -o|--output)
            OUTPUT_DIR="$2"
            shift 2
            ;;
        -s|--severity)
            SEVERITY_LEVELS="$2"
            shift 2
            ;;
        --install-trivy)
            INSTALL_TRIVY=true
            shift
            ;;
        --no-build)
            SKIP_BUILD=true
            shift
            ;;
        -h|--help)
            show_usage
            exit 0
            ;;
        *)
            print_error "Unknown option: $1"
            show_usage
            exit 1
            ;;
    esac
done

# Main execution
main() {
    print_status "Starting container security scan..."
    
    # Install Trivy if requested
    if [ "$INSTALL_TRIVY" = true ]; then
        install_trivy
    fi
    
    # Check if Trivy is available
    if ! command_exists trivy; then
        print_error "Trivy is not installed. Use --install-trivy option or install it manually."
        print_status "Installation guide: https://aquasecurity.github.io/trivy/latest/getting-started/installation/"
        exit 1
    fi
    
    # Build image if not skipped
    if [ "$SKIP_BUILD" = false ]; then
        build_image
    fi
    
    # Run vulnerability scan
    run_scan
    
    # Parse and display results
    if parse_results; then
        print_success "Container security scan completed successfully"
        exit 0
    else
        print_error "Container security scan found critical or high severity vulnerabilities"
        exit 1
    fi
}

# Run main function
main "$@"