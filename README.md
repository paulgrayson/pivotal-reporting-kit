Pivotal Reporting Kit provides a nice API for extracting reporting data from the Pivotal Tracker API

Uses [PivotalTracker's v5 beta API](https://www.pivotaltracker.com/help/api/rest/v5)

## Status
Still very much in development - see TODO below

## Setup
1. Copy `.env.example` as `.env`
1. Get your PivotalTracker API token, go to your [pivotal profile page](https://www.pivotaltracker.com/profile), scroll down until you see `API token`
1. Edit `.env` and set the value of `export PIVOTAL_API_TOKEN="YOUR API TOKEN HERE"` to your PivotalTracker API token.

## Examples

### Get all projects accessible by account

	> QueryAccount.new.project_ids
	=> [268755, 3687807, 1559109, 2726685]

### Count all stories in project

	> QueryProject.new(268755).count
	=> 52
	
### Count stories in project with the label 'needs merge' in the current iteration

	> QueryProject.new(268755).label('needs merge').count
	=> 4
	
### Count stories in project with the label 'needs merge' and include those done in previous iterations

	> QueryProject.new(268755).label('needs merge').include_done.count
	=> 9
	
### Count stories in project with the label 'flaky' that have not been started (unstarted)

	> QueryProject.new(268755).label('flaky').status(:unstarted).count
	=> 12

### Count stories accepted since 1 week ago

	> QueryProject.new(268755).accepted(since: 1.week.ago).count
	=> 7
	
### Count stories accepted before 2 days ago with labels 'flaky' and 'needs merge'

	Note:
	`labels` is an alias for `label`.
	`label` accepts multiple labels.
	> QueryProject.new(268755).accepted(before: 2.days.ago).labels('flaky', 'needs merge')


## TODO
1. Allow combination of state changed filter with others by switching from e.g. `accepted_before` param and instead add a `accepted_before:<when>` clause to the `filter` param
1. Implement aggregate queries across all projects e.g. `QueryAccount.new.all_projects.label('flaky').status(:unstarted).count`
1. Make this a gem


