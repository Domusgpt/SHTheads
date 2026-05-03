from playwright.sync_api import sync_playwright

def run_test():
    with sync_playwright() as p:
        browser = p.chromium.launch()
        page = browser.new_page()
        page.goto('http://localhost:8080/SHTheads/#/tradesman/feed')
        page.wait_for_timeout(5000)
        page.screenshot(path='verification/playwright_feed.png')
        browser.close()

if __name__ == "__main__":
    run_test()
