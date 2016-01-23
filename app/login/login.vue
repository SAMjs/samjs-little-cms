<template lang="jade">
modal#login(style="max-width:30rem;min-height:20.2rem" @hide="reset" v-ref:modal)
  .modal-content.center-align
    h4 Login
    input-field(
      label="Benutzername"
      icon="mdi-social-person"
      autofocus="true"
      input-id="name"
      @change="nameChanged"
      @confirm="focusPw"
      v-bind:value.sync="name"
      )
    input-field(
      label="Passwort"
      type="password"
      input-id="password"
      @change="pwChanged"
      @confirm="click"
      v-bind:value.sync="password"
      v-ref:password
      )
    .preloader-wrapper.small(v-bind:class="{active:state.active}")
      .spinner-layer.spinner-blue-only
        .circle-clipper.left
          .circle
        .gap-patch
          .circle
        .circle-clipper.right
          .circle
    button.btn(@click="click" v-bind:disabled="state.active" v-bind:class="{disabled:state.active||!state.complete}" tabindex="0") Absenden


    .failed(v-show="state.failed") Failed
</template>

<script lang="coffee">
samjs = require "./samjs.coffee"
module.exports =
  replace: false

  components:
    "input-field": require "vue-materialize/input-field"
    "modal": require "vue-materialize/modal"
  data: ->
    name: ""
    password: ""
    resolve: null
    reject: null
    state:
      active: false
      failed: false
      complete: false
  el: -> document.createElement "div"
  methods:
    reset: ->
      @reject?()
      @state =
        active: false
        failed: false
        complete: false
      @name = ""
      @password = ""
      @resolve= null
      @reject= null
    click: ->
      @state.active = true
      @state.failed = false
      samjs.auth.login(name: @name, pwd:@password)
      .then =>
        @resolve()
        @reject = null
        @$refs.modal.close()
      .catch (e) =>
        @password = ""
        @focusPw()
        setTimeout (=>@state.failed = true), 200
        return null
      .finally =>
        @state.active = false
    open: ->
      @$refs.modal.open()
      return new Promise (resolve,reject) =>
        @resolve = resolve
        @reject = reject
    focusPw: ->
      @$refs.password.focus()
    nameChanged: ->
      @password = ""
    pwChanged: ->
      @state.failed = false
      if @password
        @state.complete = true
      else
        @state.complete = false
</script>

<style lang="stylus">
#login
  &>.modal-content
    &>h4
      margin-bottom: 3rem
    &>.preloader-wrapper
      position absolute
      bottom 1.7rem
      left 6.5rem
    &>.failed
      position: absolute
      bottom 2.1rem
      right 2rem
</style>
