*** Settings ***
Documentation     Simple example using SeleniumLibrary.
Library           SeleniumLibrary
Library           ChromeConfiguration.py

*** Variables ***
${SITEURL}      http://google.com

*** Test Cases ***
Google opens
    ${chrome_opts}      ChromeConfiguration.Config
    @{ARGS}             ChromeConfiguration.Serviceargs
    Create WebDriver    Chrome  chrome_options=${chrome_opts}   service_args=${ARGS}
    Go To               ${SITEURL}
    Title Should Be     Google
    Capture Page Screenshot     google.png
    [Teardown]          Close Browser

