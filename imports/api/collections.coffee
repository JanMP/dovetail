{ Mongo } = require "meteor/mongo"

Bars = new Mongo.Collection "bars"
Bars.schema = new SimpleSchema
  searchString :
    type : String
  yelpId :
    type : String
  name :
    type : String
  address :
    type : [String]
    optional : true
  imageUrl :
    type : String
    optional : true

Bars.attachSchema Bars.schema

exports.Bars = Bars

Going = new Mongo.Collection "going"
Going.schema = new SimpleSchema
  yelpId :
    type : String
  userId :
    type : String
  date :
    type : Date
Going.attachSchema Going.schema
exports.Going = Going
