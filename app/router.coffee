module.exports = new class Router
  routes: []
  mode: null
  root: '/'
  constructor: ->
    @mode = if history.pushState? then 'history' else 'hash'
    return @
  getFragment: ->
    fragment = ''
    if @mode == 'history'
      fragment = @clearSlashes(decodeURI(location.pathname + location.search))
      fragment = fragment.replace(/\?(.*)$/, '')
      fragment = if @root != '/' then fragment.replace(@root, '') else fragment
    else
      match = window.location.href.match(/#(.*)$/)
      fragment = if match then match[1] else ''
    return @clearSlashes fragment
  clearSlashes: (path) ->
    return path.toString().replace(/\/$/, '').replace /^\//, ''
  add: (re, handler) ->
    if typeof re == 'function'
      handler = re
      re = ''
    @routes.push
      re: re
      handler: handler
    return @
  navigate: (path) =>
    path = if path then path else ''
    if @mode == 'history'
      history.pushState null, null, @root + @clearSlashes(path)
    else
      window.location.href = window.location.href.replace(/#(.*)$/, '') + '#' + path
    @check(path)
    return @
  check: (f) ->
    fragment = f or @getFragment()
    i = 0
    while i < @routes.length
      match = fragment.match(@routes[i].re)
      if match
        match.shift()
        @routes[i].handler.apply {}, match
        document.getElementById("body").scrollIntoView()
        return @
      i++
    return @
  listen: =>
    onclick = (e) =>
      element = null
      if e.target.nodeName == "A"
        element = e.target
      else if e.target.parentElement?.nodeName == "A"
        element = e.target.parentElement
      if element?.baseURI.indexOf(element.host)>-1
        @navigate element.pathname
        e.preventDefault()
    document.addEventListener "click", onclick, false
    return @
