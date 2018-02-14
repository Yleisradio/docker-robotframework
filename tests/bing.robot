*** Settings ***
Documentation     Simple example using SeleniumLibrary.
Library           SeleniumLibrary
Library           ChromeConfiguration.py
Default Tags      bing

*** Variables ***
${SITEURL}      http://bing.com

*** Test Cases ***
Bing opens
    ${chrome_opts}      ChromeConfiguration.Config
    @{ARGS}             ChromeConfiguration.Serviceargs
    Create WebDriver    Chrome  chrome_options=${chrome_opts}   service_args=${ARGS}
    Go To               ${SITEURL}
    Title Should Be     Bing
    Capture Page Screenshot  bing.png
    [Teardown]          Close Browser

