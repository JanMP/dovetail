{Meteor} = require "meteor/meteor"

#require "/imports/ui/home/home.styl"
require "/imports/ui/home/home.jade"
require "/imports/api/methods.coffee"
{ Bars, Going } = require "/imports/api/collections.coffee"

Template.home.viewmodel
  locationInput : ""
  locationQuery : ""
  submit : (event) ->
    event.preventDefault()
    @locationQuery @locationInput()
    if Meteor.userId()
      Meteor.call "dovetail.saveLocation",
        locationQuery : @locationQuery()
    else
      window.localStorage.setItem "locationQuery", @locationQuery()
  bars : ->
    Bars.find
      searchString : @locationQuery()
  loading : ->
    not @templateInstance.subscriptionsReady()
  autorun : ->
    locationQuery = Meteor.user()?.profile.locationQuery or
    window.localStorage.getItem("locationQuery") or ""
    @locationInput locationQuery
    @locationQuery locationQuery
    @templateInstance.subscribe "barsAtLocation", @locationQuery()

Template.barView.viewmodel
  areGoing : ->
    Going.find( yelpId : @yelpId() ).count()
  imGoing : ->
    selector =
      userId : Meteor.userId()
      yelpId : @yelpId()
    Going.findOne(selector)?
  toggleGoing : ->
    if Meteor.userId()
      Meteor.call "dovetail.toggleGoing",
        yelpId : @yelpId()
  autorun : ->
    @templateInstance.subscribe "goingToBar", @yelpId()
