declare global {
  interface Window {
    swift: any,
    addVersion(version: string): any,
  }
}

window.addVersion = (version: string) => console.log(version);

const swift = window.swift;

function getCurrentVersion(): string {
  return swift.getCurrentVersion();
}

export { getCurrentVersion };
