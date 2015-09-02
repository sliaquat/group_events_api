# README

Group Events is an app that lets you manage Group Events that run for whole days using an API.
 
#### API End Points
 + `GET: /group_events` Lists all group events
 + `GET: /group_events/id` Show a group event with the given id
 + `PUT/PATCH: /group_events/id` Update an existing group event for the given id with provided attributes
 + `POST: /group_events` Create a new group event with the provided attributes
+ `DELETE: /group_events/id` Delete an existing group event with the provided id

#### Example attributes:
 
 ```json
    {
      "group_event": {
        "name": "Event Name",
        "description": "Event description",
        "location": "101 West Pinehurst St. San Francisco, CA 94538 ",
        "start_date": "2015-09-03",
        "end_date": "2015-09-04",
        "duration": "1",
        "status": "draft"
      }
    }
 ```
 
#### Things to know:
 
 + 'name', 'description', 'location, 'start_date', 'end_date', 'duration' attributes are optional when a group event is in 'draft' status.
 + All attributes are required to publish an event. 
 + If 'start_date' and 'end_date' is provided, duration is calucated automatically even if duration is provided as an attribute.
 + If 'duration' is provided and one of 'start_date' and 'end_date' are are provided, the other date is calculated automatically.
 + end_date should always be after start_date
 + On deleting a group event, it is marked as deleted and continues to exist in the database. 
 