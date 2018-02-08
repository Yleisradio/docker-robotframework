from selenium.webdriver.chrome.options import Options

def config():
    options = Options()
    options.add_argument("--no-sandbox")
    options.add_argument('--headless')
    options.add_argument("window-size=1680,1050")
    return options

def serviceargs():
    return ["--verbose", "--log-path=/tests/chromedriverlog"]
