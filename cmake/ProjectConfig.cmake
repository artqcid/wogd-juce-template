# Read project configuration from JSON
file(READ "${CMAKE_CURRENT_SOURCE_DIR}/../project-config.json" PROJECT_CONFIG_JSON)

# Parse JSON values
string(JSON PROJECT_NAME GET ${PROJECT_CONFIG_JSON} "project" "name")
string(JSON PRODUCT_NAME GET ${PROJECT_CONFIG_JSON} "project" "displayName")
string(JSON MY_PROJECT_VERSION GET ${PROJECT_CONFIG_JSON} "project" "version")
string(JSON COMPANY_NAME GET ${PROJECT_CONFIG_JSON} "project" "company")
string(JSON BUNDLE_ID GET ${PROJECT_CONFIG_JSON} "project" "bundleId")
string(JSON PLUGIN_CODE GET ${PROJECT_CONFIG_JSON} "project" "pluginCode")
string(JSON MANUFACTURER_CODE GET ${PROJECT_CONFIG_JSON} "project" "manufacturerCode")\n\n# Parse GUI configuration\nstring(JSON GUI_DEV_PORT GET ${PROJECT_CONFIG_JSON} "gui" "devPort")


# Set variables as CMake variables for use in parent project
set(PROJECT_NAME "${PROJECT_NAME}" PARENT_SCOPE)
set(PRODUCT_NAME "${PRODUCT_NAME}" PARENT_SCOPE)
set(MY_PROJECT_VERSION "${MY_PROJECT_VERSION}" PARENT_SCOPE)
set(COMPANY_NAME "${COMPANY_NAME}" PARENT_SCOPE)
set(BUNDLE_ID "${BUNDLE_ID}" PARENT_SCOPE)
set(PLUGIN_CODE "${PLUGIN_CODE}" PARENT_SCOPE)
set(MANUFACTURER_CODE "${MANUFACTURER_CODE}" PARENT_SCOPE)\nset(GUI_DEV_PORT "${GUI_DEV_PORT}" PARENT_SCOPE)
message(STATUS "Project: ${PROJECT_NAME} v${MY_PROJECT_VERSION}")
message(STATUS "Company: ${COMPANY_NAME}")\nmessage(STATUS "GUI Dev Port: ${GUI_DEV_PORT}")
