<template lang="jade">
#install-container
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
      span.card-title.black-text Please create a root user
      p.
        Please create a root user now.
      input-field(
        v-ref:nameinput
        input-id="username"
        label="Benutzername"
        icon="icon-user"
        v-bind:on-confirm="focusPw"
      )
      input-field(
        v-ref:pwinput
        input-id="password"
        v-bind:validate="validatePw"
        data-error="mind. 8 Zeichen"
        label="Passwort"
        type="password"
        icon="icon-user"
        v-bind:on-confirm="saveUser"
      )
    .card-action.right-align(v-bind:v-if="$refs.nameinput.value && $refs.pwinput.isValid")
      a(@click="saveUser") ok
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
{Velocity} = require("vue-materialize")

module.exports =
  components:
    "input-field": require "vue-materialize/input-field"
  data: ->
    state: "start"
    dberror: ""
    dbsuccess: ""
    samjs: {}
  methods:
    goUser: ->
      @state = "user"
      @$nextTick =>
        @$refs.nameinput.focus()
    goFinished: ->
      @state = "finished"
      @$nextTick =>
        @$els.finished.focus()
    focusPw: ->
      @$refs.pwinput.focus()
    finished: ->
    saveUser: ->
      @samjs.auth.createRoot name: @$refs.nameinput.value, pwd: @$refs.pwinput.value
      .then @goFinished
    validatePw: (pw) ->
      return false if pw.length < 8
      return true
    start: ->
      @samjs.install.isInConfigMode()
      .then @goUser
  ready: ->
    @$els.start.focus()
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
