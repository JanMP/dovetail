require "/imports/ui/navbar/navbar.jade"
require "/imports/ui/yelpButton/yelpButton.jade"
require "/imports/ui/layout/layout.jade"
require "/imports/ui/home/home.coffee"
require "/imports/ui/info/info.coffee"

FlowRouter.route "/",
  name : "home"
  action : ->
    BlazeLayout.render "layout",
      main : "home"

FlowRouter.route "/info",
  name : "info"
  action : ->
    BlazeLayout.render "layout",
      main : "info"
