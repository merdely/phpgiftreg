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

<div class="navbar navbar-expand-lg navbar-light bg-light fixed-top">
		<div class="container-fluid">
			<button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
				<span class="navbar-toggler-icon"></span>
			</button>
			<a class="navbar-brand" href="index.php">
                        <img src="images/wishlist.png" height=25px width=25px /> Gift Registry</a>
			<div id="main-menu" class="collapse navbar-collapse">
				<ul id="main-menu-left" class="navbar-nav">
					<li class="nav-item"><a href="shoplist.php">My Shopping List</a></li>
					<li class="nav-item"><a href="mylist.php">My Items (printable)</a></li>
				</ul>
				<ul id="main-menu-right" class="nav pull-right">
					<li class="nav-item"><a href="profile.php">Update Profile</a></li>
					<li class="nav-item"><a href="event.php">Manage Events</a></li>
					{if $isadmin}
						<li class="nav-item dropdown">
							<a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
								Admin
								<b class="caret"></b>
							</a>
							<ul class="dropdown-menu" aria-labelledby="navbarDropdown">
								<li><a class="dropdown-item" href="users.php">Manage Users</a></li>
								<li><a class="dropdown-item" href="families.php">Manage Families</a></li>
								<li><a class="dropdown-item" href="categories.php">Manage Categories</a></li>
								<li><a class="dropdown-item" href="ranks.php">Manage Ranks</a></li>
							</ul>
						</li>
					{/if}
					<li class="nav-item"><a href="login.php?action=logout">Logout</a></li>
					<li class="nav-item"><a href="help.php">Help</a></li>
				</ul>
			</div>
		</div>
</div>
