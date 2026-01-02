# Read project configuration from JSON
file(READ "${CMAKE_CURRENT_SOURCE_DIR}/../project-config.json" PROJECT_CONFIG_JSON)

# Parse JSON values
string(JSON PROJECT_NAME GET ${PROJECT_CONFIG_JSON} "project" "name")
string(JSON PRODUCT_NAME GET ${PROJECT_CONFIG_JSON} "project" "displayName")
string(JSON MY_PROJECT_VERSION GET ${PROJECT_CONFIG_JSON} "project" "version")
string(JSON COMPANY_NAME GET ${PROJECT_CONFIG_JSON} "project" "company")
string(JSON BUNDLE_ID GET ${PROJECT_CONFIG_JSON} "project" "bundleId")
string(JSON PLUGIN_CODE GET ${PROJECT_CONFIG_JSON} "project" "pluginCode")
string(JSON MANUFACTURER_CODE GET ${PROJECT_CONFIG_JSON} "project" "manufacturerCode")


# Set MY_PROJECT_VERSION as a CMake variable for use in parent project
set(MY_PROJECT_VERSION "${MY_PROJECT_VERSION}" PARENT_SCOPE)
message(STATUS "Project: ${PROJECT_NAME} v${MY_PROJECT_VERSION}")
message(STATUS "Company: ${COMPANY_NAME}")
