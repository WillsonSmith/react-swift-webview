declare global {
  interface Window {
    webkit: any,
    resolvePromise(promiseId: number, data: any, error: any): any,
  }
}

let promiseCount = 0;
const promises = {};

window.resolvePromise = function(promiseId: number, data:any, error) {
  if (error) {
    return promises[promiseId].reject(data);
  }
  promises[promiseId].resolve(data);
  promises[promiseId] = null;
  delete promises[promiseId];
};

// window.addVersion = (version: string) => console.log(version);

const swift = (swiftFunction: string): Promise<String> => {
  var promise = new Promise<String>((resolve, reject) => {
    promiseCount++;
    promises[promiseCount] = { resolve, reject };
    try {
      window.webkit.messageHandlers.callbackHandler.postMessage({
        promiseId: promiseCount, functionToRun: swiftFunction
      });
    } catch (error) {
      console.log(error);
    }
  });
  return promise;
};

function getCurrentVersion(): Promise<String> {
  return swift('getCurrentVersion');
}

export { getCurrentVersion };
