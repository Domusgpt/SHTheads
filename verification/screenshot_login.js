const { chromium } = require('playwright');

(async () => {
  const browser = await chromium.launch();
  const page = await browser.newPage();

  page.on('console', msg => console.log('BROWSER CONSOLE:', msg.text()));
  page.on('pageerror', error => console.log('BROWSER ERROR:', error.message));

  await page.goto('http://localhost:8080/SHTheads/');

  await page.waitForTimeout(3000);

  // Fill email and password (doesn't matter what, it's mock)
  await page.fill('input[type="text"]', 'test@test.com');
  await page.fill('input[type="password"]', 'password');

  // Click login button (the text is LOGIN)
  await page.click('text="LOGIN"');

  await page.waitForTimeout(5000);

  await page.screenshot({ path: 'verification/after_login.png' });

  // Also go to feed screen
  await page.click('text="Feed"'); // assuming there's a feed tab

  await page.waitForTimeout(3000);

  await page.screenshot({ path: 'verification/feed_screen.png' });

  await browser.close();
})();
