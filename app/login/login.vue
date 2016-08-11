<template lang="pug">
modal(@hide="reset" v-ref:modal)
  .modal-content.center-align
    h4 Login
    .row(style="text-align:left")
      input-field.s12(
        label="Username"
        autofocus
        @change="nameChanged"
        @confirm="focusPw"
        v-bind:value.sync="name"
      )
        icon.prefix(slot="icon" name="material-person")
    .row(style="text-align:left")
      input-field.s12(
        v-bind:validate="validatePw"
        label="Password"
        type="password"
        @change="pwChanged"
        @confirm="click"
        v-bind:value.sync="password"
        v-ref:password
      )
        icon.prefix(slot="icon" name="material-vpn_key")
    .row
      .col.s4.m4
        .preloader-wrapper.small(v-bind:class="{active:state.active}")
          .spinner-layer.spinner-blue-only
            .circle-clipper.left
              .circle
            .gap-patch
              .circle
            .circle-clipper.right
              .circle
      .col.s8.m4
        waves
          button.btn(@click="click" v-bind:disabled="state.active" v-bind:class="{disabled:state.active||!state.complete}" tabindex="0") Absenden
      .col.s12.m4
        .failed.red-text(v-show="state.failed") Failed
</template>

<script lang="coffee">
samjs = require "./samjs.coffee"
module.exports =
  replace: false

  components:
    "input-field": require "vue-materialize/input-field"
    "modal": require "vue-materialize/modal"
    "icon": require "vue-materialize/icon"
    "waves": require "vue-materialize/waves"
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
        console.log e
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
