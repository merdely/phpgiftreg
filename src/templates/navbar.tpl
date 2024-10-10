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
{*
Inspired from https://getbootstrap.com/docs/4.0/components/navbar/#supported-content
*}

<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
<div class="container">
  <a class="navbar-brand" href="index.php"><img src="images/wishlist.png" height=25px width=25px /> Test Gift Registry</a>
  <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
    <span class="navbar-toggler-icon"></span>
  </button>

  <div class="collapse navbar-collapse" id="navbarSupportedContent">
    <ul class="navbar-nav">
      <li class="nav-item active">
        <a class="nav-link" href="shoplist.php">My Shopping List</a>
      </li>
      <li class="nav-item">
        <a class="nav-link" href="mylist.php">My Items (printable)</a>
      </li>
    </ul>
  </div>
  <div class="collapse navbar-collapse" id="navbarSupportedContent">
    <ul class="navbar-nav ms-auto">
      {if $isadmin}
      <li class="nav-item dropdown" data-bs-theme="dark">
        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
          Admin
        </a>
        <div class="dropdown-menu" aria-labelledby="navbarDropdown">
          <a class="dropdown-item" href="users.php">Manage Users</a>
          <a class="dropdown-item" href="families.php">Manage Families</a>
          <a class="dropdown-item" href="categories.php">Manage Categories</a>
          <a class="dropdown-item" href="ranks.php">Manage Ranks</a>
        </div>
      </li>
      {/if}
      <li class="nav-item">
        <a class="nav-link" href="profile.php">Update Profile</a>
      </li>
      <li class="nav-item">
        <a class="nav-link" href="event.php">Manage Events</a>
      </li>
      <li class="nav-item">
        <a class="nav-link" href="login.php?action=logout">Logout</a>
      </li>
      <li class="nav-item">
        <a class="nav-link" href="help.php">Help</a>
      </li>
    </ul>
  </div>
  </div>
</nav>
