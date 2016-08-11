<template lang="pug">
#install-container.container
  .card.black-text(
    v-el:start
    tabindex="-1"
    transition="slide"
    v-if="state == 'start'"
    @keyup.13 ="start")
    .card-content
      span.card-title.black-text Samjs
      p You are now taken through installation
    .card-action.right-align
      a(@click="start") Let's start
  .card.black-text(transition="slide" v-if="state == 'user'")
    .card-content
      span.card-title.black-text Creation of root user
      .row
        input-field.s12(
          readonly
          v-bind:value="username"
          label="Username"
        )
          icon.prefix(slot="icon" name="material-person")
        input-field.s12(
          autofocus
          v-ref:pwinput
          v-bind:validate="validatePw"
          data-error="use at least 8 characters"
          label="Password"
          type="password"
          @valid="onValid"
          @invalid="onInvalid"
          @confirm="saveUser"
        )
          icon.prefix(slot="icon" name="material-vpn_key")
    .card-action.right-align(v-if="isValid")
      a(@click="saveUser") Save
  .card.black-text(
    v-el:finished
    tabindex="-1"
    transition="slide"
    v-if="state == 'finished'"
    @keyup.13 ="finished")
    .card-content
      span.card-title.black-text Done!
      p.
        Have fun with samjs little cms
    .card-action.right-align
      a(@click="finished") Done
</template>
<script lang="coffee">
Velocity = require("velocity-animate")

module.exports =
  components:
    "input-field": require "vue-materialize/input-field"
    "icon": require "vue-materialize/icon"
  data: ->
    state: "start"
    username: ""
    isValid: false
    samjs: {}
  methods:
    finished: ->
      document.location.reload()
    onValid: ->
      @isValid = true
    onInvalid: ->
      @isValid = false
    goFinished: ->
      @state = "finished"
      @$nextTick =>
        @$els.finished.focus()
    saveUser: ->
      @samjs.auth.createRoot @$refs.pwinput.value
      .then @goFinished
    validatePw: (pw) ->
      return false if pw.length < 8
      return true
    start: ->
      @samjs.install.isInConfigMode()
      .then (nsp) =>
        @samjs.io.nsp(nsp).getter "auth.getInstallationInfo"
      .then (info) =>
        @username = info.rootUser
        @state = "user"
  ready: ->
    @$els.start?.focus()
  transitions:
    "slide":
      enter: (el, done) ->
        Velocity.hook el, "translateY", "70%"
        #Velocity.hook el, "translateY", "-70%"
        Velocity.hook el, "scaleX", "90%"
        Velocity el, {translateY: "0", opacity: 1,scaleX: 1},
          {duration: 300
          ease: "easeOutCubic"
          queue:false
          complete: done}
      leave: (el, done) ->
        translateY = "-70%"
        # translateY = "70%"
        Velocity el, {translateY: translateY, opacity: 0,scaleX: 0.9},
          {duration: 300
          ease: "easeOutCubic"
          queue:false
          complete: done}
</script>
<style lang="stylus">
#install-container
  position: relative
  .slide-enter,.slide-leave
    position: absolute
    width: 100%
    top: 0
  .slide-enter
    opacity: 0
</style>
