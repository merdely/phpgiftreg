{*
This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
*}

<!DOCTYPE html>
<html lang="en">
<head>
	<title>{$opt.app_name} - Manage Events</title>
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<link href="css/phpgiftreg.css" rel="stylesheet">
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5/dist/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">
	<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1/font/bootstrap-icons.min.css" rel="stylesheet" crossorigin="anonymous">
	<script src="https://cdn.jsdelivr.net/npm/jquery@3/dist/jquery.min.js" crossorigin="anonymous"></script>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
	<script src="https://cdn.jsdelivr.net/npm/jquery-validation@1/dist/jquery.validate.min.js" crossorigin="anonymous"></script>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap-datepicker@1/dist/css/bootstrap-datepicker3.min.css" rel="stylesheet" crossorigin="anonymous">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap-datepicker@1/dist/js/bootstrap-datepicker.min.js" crossorigin="anonymous"></script>
	<script src="js/themeswitcher.js"></script>
</head>
<body>
	{include file='navbar.tpl' isadmin=$isadmin}
	<main>
		<div class="container">
			{if isset($message)}
				<div class="alert alert-success" role="alert">
					{$message|escape:'htmlall'}
				</div>
			{/if}
			{if isset($error_message)}
				<div class="alert alert-danger" role="alert">
					{$error_message|escape:'htmlall'}
				</div>
			{/if}
			{if $opt.show_helptext}
				<div class="card text-bg-info mb-3">
					<div class="card-header">Help</div>
					<div class="card-body">
							Here you can specify events <strong>of your own</strong>, like your birthday or your anniversary.  When the event occurs within {$opt.event_threshold} days, an event reminder will appear in the display of everyone who shops for you.
							{if $isadmin}
								<strong>System events</strong> are events which belong to no one -- like Christmas -- and will appear on everyone's display.
							{/if}
							Marking an item as <strong>Recurring yearly</strong> will cause them to show up year after year.
					</div>
				</div>
			{/if}
			<div class="card mb-3">
				<div class="card-header"><h1>Events</h1></div>
				<div class="card-body">
					<div class="table-responsive">
						<table class="table table-bordered table-striped">
							<thead>
								<tr>
									<th>Event date</th>
									<th>Description</th>
									<th>Recurring?</th>
									{if $isadmin}
										<th>System event?</th>
									{/if}
									<th>&nbsp;</th>
								</tr>
							</thead>
							<tbody>
								{foreach from=$events item=row}
									<tr>
										<td>{$row.eventdate}</td>
										<td>{$row.description|escape:'htmlall'}</td>
										<td>{if $row.recurring}Yes{else}No{/if}</td>
										{if $isadmin}
											<td>
												{if $row.userid == ''}Yes{else}No{/if}
											</td>
										{/if}
										<td>
											<a href="event.php?action=edit&eventid={$row.eventid}"><img alt="Edit Event" class="theme-image" data-light-src="images/pencil-light.png" data-dark-src="images/pencil-dark.png" src="images/pencil-light.png" border="0" title="Edit Event" /></a>&nbsp;<a href="event.php?action=delete&eventid={$row.eventid}"><img alt="Delete Event" class="theme-image" data-light-src="images/bin-light.png" data-dark-src="images/bin-dark.png" src="images/bin-light.png" border="0" title="Delete Event" /></a>
										</td>
									</tr>
								{/foreach}
							</tbody>
						</table>
					</div> <!-- table-responsive -->
				</div> <!-- card-body -->
			</div> <!-- card -->
			<div class="row row-cols-1 row-cols-md-2 g4 d-flex d-flex justify-content-center">
				<div class="col mb-3">
					<div class="card h-100">
						<form name="eventform" id="eventform" method="get" action="event.php" class="well form-horizontal">
							<div class="card-header">Event Details</div>
							<div class="card-body">
								{if $action == "edit" || (isset($haserror) && $action == "update")}
									<input type="hidden" name="eventid" value="{$eventid}">
									<input type="hidden" name="action" value="update">
								{elseif $action == "" || (isset($haserror) && $action == "insert")}
									<input type="hidden" name="action" value="insert">
								{/if}
								<div class="row row-cols-2 g-3 mb-2 align-items-center">
									<div class="col-4">
										<label class="col-form-label" for="description">Description</label>
									</div>
									<div class="col">
										<input id="description" name="description" type="text" value="{$description|escape:'htmlall'}" class="form-control{if isset($description_error)} is-invalid{/if}" maxlength="255" placeholder="Description" aria-describedby="description-helper" required>
									</div>
								</div>
								<div class="row row-cols-2 g-3 mb-2 align-items-center">
									<div class="col-4">
										<label class="col-form-label" for="eventdate">Event date</label>
									</div>
									<div class="col">
										<input id="eventdate" name="eventdate" type="text" value="{$eventdate|escape:'htmlall'}" class="form-control{if isset($eventdate_error)} is-invalid{/if}" placeholder="mm/dd/yyyy" data-date-format="mm/dd/yyyy" data-provide="datepicker" aria-describedby="eventdate-helper" required>
									</div>
								</div>
								<div class="row row-cols-2 g-3 align-items-center">
									<div class="col-4">
										<label class="col-form-label" for="recurring">Recurring</label>
									</div>
									<div class="col">
										<input type="checkbox" name="recurring" {if $recurring}CHECKED{/if}>
										Recurring yearly
									</div>
									<div class="col">
									</div>
								</div>
								{if $isadmin}
									<div class="row row-cols-2 g-3 align-items-center">
										<div class="col-4">
											<label class="col-form-label" for="systemevent">System event</label>
										</div>
										<div class="col">
											<input type="checkbox" name="systemevent" {if $systemevent}CHECKED{/if}>
											System event
										</div>
										<div class="col">
										</div>
									</div> <!-- row -->
								{/if}
							</div> <!-- card-body -->
							<div class="card-footer">
								<button type="submit" class="btn btn-primary">{if $action == "" || $action == "insert"}Add{else}Update{/if}</button>
								<button type="button" class="btn" onClick="document.location.href='event.php';">Cancel</button>
							</div> <!-- card-footer -->
						</form>
					</div> <!-- card -->
				</div> <!-- col -->
			</div> <!-- row -->
		</div> <!-- container -->
	</main>
	{include file='footer.tpl'}
	{if isset($action) && $action == "edit"} <script> $(document).ready(function() { $('html, body').animate({ scrollTop: $(document).height() }, 'fast'); }); </script> {/if}
</body>
</html>
