interface CallbackHandler {
  postMessage(message: object): void;
}

interface MessageHandlers {
  callbackHandler: CallbackHandler;
}

interface Webkit {
  messageHandlers: MessageHandlers;
}

declare global {
  interface Window {
    webkit: Webkit;
    resolvePromise(promiseId: number, data: any, error: any): void;
  }
}

let promiseCount: number = 0;
const promises: object = {};

window.resolvePromise = function(promiseId: number, data:any, error:any): void {
  if (error) {
    return promises[promiseId].reject(data);
  }
  promises[promiseId].resolve(data);
  promises[promiseId] = null;
  delete promises[promiseId];
};

const callSwift = (swiftFunction: string, namedArguments:any = {}): Promise<string> => {
  var promise = new Promise<string>((resolve, reject) => {
    promiseCount++;
    promises[promiseCount] = { resolve, reject };
    try {
      window.webkit.messageHandlers.callbackHandler.postMessage(
        Object.assign(
          {
            promiseId: promiseCount, functionToRun: swiftFunction
          },
          namedArguments,
        )
      );
    } catch (error) {
      console.log(error);
    }
  });
  return promise;
};

function getCurrentVersion(): Promise<string> {
  // to add arguments -- swift('getCurrentVersion', {key: value})
  // accessed the same way promiseId is accessed
  return callSwift('getCurrentVersion', {prefix: 'React-swift-webview '});
}

export { getCurrentVersion };
