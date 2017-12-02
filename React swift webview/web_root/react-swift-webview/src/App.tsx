import * as React from 'react';
import './App.css';
import { getCurrentVersion } from './swift_specifics/globals';

class App extends React.Component {

  render() {
    return (
      <div className="App">
        <h2>Welcome to web hybrid template</h2>
        <p className="App-intro">
          Version {getCurrentVersion()}
        </p>
      </div>
    );
  }
}

export default App;
