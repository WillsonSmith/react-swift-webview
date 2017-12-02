declare global {
  interface Window {
    webkit: any,
    addVersion(version: string): any,
  }
}

window.addVersion = (version: string) => console.log(version);

const swift = (swiftFunction: string): void => {
  window.webkit.messageHandlers.callbackHandler.postMessage({functionToRun: swiftFunction});
};

function getCurrentVersion(): void {
  swift('getCurrentVersion');
}

export { getCurrentVersion };
