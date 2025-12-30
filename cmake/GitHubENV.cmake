# Output environment variables for GitHub Actions CI

# This is helpful for GitHub Actions to know the product name, etc.
if(DEFINED ENV{GITHUB_ACTIONS})
    message(STATUS "GITHUB_ACTIONS detected, setting environment variables")
    file(APPEND "$ENV{GITHUB_ENV}" "PROJECT_NAME=${PROJECT_NAME}\n")
    file(APPEND "$ENV{GITHUB_ENV}" "PRODUCT_NAME=${PRODUCT_NAME}\n")
    file(APPEND "$ENV{GITHUB_ENV}" "COMPANY_NAME=${COMPANY_NAME}\n")
    file(APPEND "$ENV{GITHUB_ENV}" "VERSION=${PROJECT_VERSION}\n")
endif()
