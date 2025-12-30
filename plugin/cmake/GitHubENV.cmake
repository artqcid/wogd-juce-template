# This outputs configuration for GitHub Actions

# Set environment variables for CI/CD
if(DEFINED ENV{GITHUB_ENV})
    file(APPEND $ENV{GITHUB_ENV} "PROJECT_NAME=${PROJECT_NAME}\n")
    file(APPEND $ENV{GITHUB_ENV} "PRODUCT_NAME=${PRODUCT_NAME}\n")
    file(APPEND $ENV{GITHUB_ENV} "PROJECT_VERSION=${PROJECT_VERSION}\n")
    file(APPEND $ENV{GITHUB_ENV} "COMPANY_NAME=${COMPANY_NAME}\n")
endif()
