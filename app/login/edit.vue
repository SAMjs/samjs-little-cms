<template lang="jade">
  modal#edit(v-ref:modal style="background:white;min-width:200px;height:80%;width:80%;min-height:20.2rem")
    .modal-content
      textarea(v-el:md @scroll="onScroll" v-model="input" @close="onClose" debounce="300")
      .output.main(v-el:out v-html="input | marked")
    button.btn.btn-save.btn-floating.btn-large.mdi-content-save.mdi-2x(
      @click="click"
      v-bind:class="{disabled:!state.active}"
      v-bind:disabled="!state.active"
      tabindex="0") Save
</template>

<script lang="coffee">
samjs = require "./samjs.coffee"
module.exports =
  components:
    "modal": require "vue-materialize/modal"
  replace: false
  data: ->
    state:
      active: false
      saved: false
    file: null
    input: ""
    files: new samjs.Files("markdownFiles")
  el: -> document.createElement "div"
  methods:
    open: (file) ->
      @file = file
      @files.get("#{file}.md")
      .then (result) =>
        @input = result if result?
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
    "input": ->
      @state.active = true
  filters:
    marked: require "marked"
</script>

<style lang="stylus">
#edit
  .btn-save
    position absolute
    top 20px
    right 20px
  .modal-content
    position absolute
    bottom 0
    top 0
    left 0
    right 0
    display flex
  .modal-content textarea,
  .modal-content .output
    flex 1 1
  .modal-content .output
    overflow hidden
    padding-left 8px
</style>
