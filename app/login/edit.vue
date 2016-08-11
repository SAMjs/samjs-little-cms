<template lang="pug">
  modal(v-ref:modal,style="width:80%;height:80%")
    .modal-content.row(style="height:calc(100% - 78px);")
      .col.s12.m6(style="height:100%")
        textarea(
          v-el:md
          @scroll="onScroll"
          v-model="input"
          @close="onClose"
          @input="onChange"
          style="height:100%;resize:none"
          )
      .col.s12.m6(style="height:100%")
        .output.main(v-el:out v-html="content" style="height:100%;overflow:auto")
    .modal-footer(style="text-align:right")
      button.btn.btn-save.btn-floating(
        @click="click"
        v-bind:class="{disabled:!state.active}"
        v-bind:disabled="!state.active"
        style="margin-right:20px"
        tabindex="0")
        icon(name="material-save")
</template>

<script lang="coffee">
samjs = require "./samjs.coffee"
marked = require "marked"
module.exports =
  components:
    "modal": require "vue-materialize/modal"
    "icon": require "vue-materialize/icon"
  replace: false
  data: ->
    state:
      active: false
      saved: false
    file: null
    content: ""
    input: ""
    files: new samjs.Files("markdownFiles")
  el: -> document.createElement "div"
  methods:
    onChange: (value) ->

    open: (file) ->
      @file = file
      @files.get("#{file}.md")
      .then (result) =>
        if result?
          @input = result
          @content = marked(result)
        @$nextTick => @state.active = false
        @$refs.modal.open()
    onScroll: (val) ->
      invisibleHeight = @$els.md.scrollHeight-@$els.md.clientHeight
      percentage = @$els.md.scrollTop/invisibleHeight
      invisibleHeight = @$els.out.scrollHeight-@$els.out.clientHeight
      @$els.out.scrollTop = percentage * invisibleHeight
    click: ->
      @files.set(path:"#{@file}.md", data:@input)
      .then (result) =>
        @state.active = false
        @state.saved = true
    onClose: ->
      if @state.saved
        document.location.reload()
  watch:
    "input": (value) ->
      @next = =>
        @state.active = true
        @content = marked(value)
      unless @timeout
        @next()
        @timeout = setTimeout((=>
          @timeout = null
          @next()
          ),300)

</script>
