# grunt-configs package

Auto-generate separate grunt configuration files from your `Gruntfile.js`.

This plugin will parse your projects `Gruntfile.js` and automatically generate config files for each task configuration object it finds.
See [grunt-generate-configs][grunt-generate-configs] and [load-grunt-configs][load-grunt-configs] for more information.

It allows you to generate the configuration data in following formats:

* json
* javascript
* cson
* coffee
* yaml

## Installation

Install this plugin through the command line:

```shell
apm install grunt-configs
```

Or through the Atom Package Manager.

## Usage

Select `Generate Grunt configs` from the contextual or `Packages` menu.
Or use the default short-cut: `ctrl-alt-cmd-g`

After selecting what file format you want to use, file generation will start.

## What now?

After generating the files use [load-grunt-configs][load-grunt-configs] to load the configuration files and configure Grunt.

```shell
# install load-grunt-configs
npm install load-grunt-configs --save-dev
```

And update your `Gruntfile.js`

```js
    //loads the various task configuration files
    var configs = require('load-grunt-configs')(grunt);
    grunt.initConfig(configs); //this is where the big, fat grunt configuration object normally is declared
```


[grunt-generate-configs]: https://github.com/creynders/grunt-generate-configs
[load-grunt-configs]: https://github.com/creynders/load-grunt-configs
