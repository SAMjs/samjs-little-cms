# samjs-little-cms

A little cms meant for nearly static content.
Features a webbased installation and editor.
Updates static files on edit.

# Install

Clone repository and run `npm install`

# Usage
 - Build a Website within `/app` using whatever you like.
 - everything within `/resources` will be served
 - Keep the content which should be editable to markdown files.
 - make the specific markdown files accessible in `/server/models.coffee`
 - link up a editButton to each of your markdown includes (see `/app/login/login.coffee`)

## Deploy
(have a look at [pod](https://github.com/yyx990803/pod))
on your first deploy run
```sh
npm run build
cd deploy
git init
git add .
git commit -m "deploy"
git remote add deploy {{your remote git rep}}
git push deploy master
```

once the remote is set up you can simply run

```sh
npm run deploy
```


## Release History

 - *v0.0.1*: First release

## License
Copyright (c) 2015 Paul Pflugradt
Licensed under the MIT license.
