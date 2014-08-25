Pivotal Reporting Kit provides a nice API for extracting reporting data from the Pivotal Tracker API

Uses [PivotalTracker's v5 beta API](https://www.pivotaltracker.com/help/api/rest/v5)

## Status
Still very much in development - see TODO below

## TODO
1. Namespace inside PRKit
2. Configure api token through PRKit.configure block
1. Replace Query#include_done with Query#current_iteration and make include_done default
1. Throw an exception if when any api response is an error
1. Allow combination of state changed filter with others by switching from e.g. `accepted_before` param and instead add a `accepted_before:<when>` clause to the `filter` param
1. Make this a gem
2. Support parallel api requests using typhoeus - configure vis PRKit.configure block
3. Support pagination

## Setup
1. Copy `.env.example` as `.env`
1. Get your PivotalTracker API token, go to your [pivotal profile page](https://www.pivotaltracker.com/profile), scroll down until you see `API token`
1. Edit `.env` and set the value of `export PIVOTAL_API_TOKEN="YOUR API TOKEN HERE"` to your PivotalTracker API token.

## Examples

### Get all projects accessible by account

	> Query.account.project_ids
	=> [268755, 3687807, 1559109, 2726685]

### Count all stories in project

	> Query.project(268755).count
	=> 52
	
### Count stories in project with the label 'needs merge' in the current iteration

	> Query.project(268755).label('needs merge').count
	=> 4
	
### Count stories in all projects with the label 'needs merge' in the current iterations

	> Query.all_projects.label('needs merge').count
	=> 21
	
### Count stories in project with the label 'needs merge' and include those done in previous iterations

	> Query.project(268755).label('needs merge').include_done.count
	=> 9
	
### Count stories in project with the label 'flaky' that have not been started (unstarted)

	> Query.project(268755).label('flaky').status(:unstarted).count
	=> 12

### Count stories accepted since 1 week ago

	> Query.project(268755).accepted(since: 1.week.ago).count
	=> 7
	
### Count stories accepted before 2 days ago with labels 'flaky' and 'needs merge'

	Note:
	`labels` is an alias for `label`.
	`label` accepts multiple labels.
	> QueryProject.new(268755).accepted(before: 2.days.ago).labels('flaky', 'needs merge')

