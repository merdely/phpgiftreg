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
	<title>{$opt.app_name} - Receive an Item</title>
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<link href="css/phpgiftreg.css" rel="stylesheet">
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5/dist/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">
	<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1/font/bootstrap-icons.min.css" rel="stylesheet" crossorigin="anonymous">
	<script src="https://cdn.jsdelivr.net/npm/jquery@3/dist/jquery.min.js" crossorigin="anonymous"></script>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
	<script src="https://cdn.jsdelivr.net/npm/jquery-validation@1/dist/jquery.validate.min.js" crossorigin="anonymous"></script>
	<script src="js/themeswitcher.js"></script>
</head>
<body>
	{include file='navbar.tpl' isadmin=$isadmin}
	<main>
		<div class="container">
			<div class="row row-cols-1 row-cols-md-2 g4 d-flex d-flex justify-content-center">
				<div class="col mb-3">
					<div class="card h-100">
						<form name="receiverform" id="receiverform" method="get" action="receive.php" class="well form-horizontal">
							<div class="card-header"><h1>Mark Item Received</h1></div>
							<div class="card-body">
								<input type="hidden" name="action" value="receive">
								<input type="hidden" name="itemid" value="{$itemid}">
								<div class="row row-cols-2 g-3 mb-2 align-items-center">
									<div class="col-4">
										<label class="col-form-label" for="buyer">Buyer</label>
									</div>
									<div class="col">
										<select id="buyer" name="buyer" class="form-select" required>
											<option value="">(select buyer)</option>
											{foreach from=$buyers item=row}
												<option value="{$row.userid}">{$row.fullname|escape:'htmlall'}</option>
											{/foreach}
										</select>
									</div>
								</div>
								<div class="row row-cols-2 g-3 align-items-center">
									<div class="col-4">
										<label class="col-form-label" for="quantity">Quantity received (maximum of {$quantity})</label>
									</div>
									<div class="col">
										<input type="text" id="quantity" name="quantity" class="form-control" value="1" maxlength="3" aria-describedby="help-block" required>
										<span id="help-block" class="form-text">Once you have received all of an item, it will be deleted.</span>
									</div> <!-- col -->
								</div> <!-- row -->
							</div> <!-- card body -->
							<div class="card-footer">
								<button type="submit" class="btn btn-primary">Receive Item</button>
								<button type="button" class="btn" onClick="document.location.href='index.php';">Cancel</button>
							</div> <!-- card footer -->
						</form>
					</div> <!-- card -->
				</div> <!-- col -->
			</div> <!-- row -->
		</div> <!-- container -->
	</main>
	{include file='footer.tpl'}
</body>
</html>
