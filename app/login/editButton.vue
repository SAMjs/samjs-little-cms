<template lang="pug">
  button.btn.btn-edit.btn-floating.btn-large.mdi-editor-mode-edit.mdi-2x(@click="click" tabindex="0")
    icon(name="material-mode_edit")
</template>

<script lang="coffee">

module.exports =
  components:
    "icon": require "vue-materialize/icon"
  replace: false
  props:
    filename:
      type: String
  data: ->
    edit: null
  el: -> document.createElement "div"
  methods:
    click: -> @edit.open(@filename)

</script>

<style lang="stylus">
.btn-edit
  position absolute
  top 20px
  right 20px
</style>
