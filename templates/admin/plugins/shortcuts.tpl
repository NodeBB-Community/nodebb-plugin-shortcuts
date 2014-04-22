<h1>Shortcuts</h1>
<hr />

<form>
  <div class="row">
    <p>
      <h2>Stuff</h2>
      Color of selection-shadow: <input data-key="selectionColor" type="color" /><br>
      Delay between repeating action while key hold down: <input data-key="timeSpace" type="number" step="50" />
    </p>
    <p>
      <h2>Actions</h2>
      <p id="shortcuts-actions"></p>
    </p>
  </div>
  <button class="btn btn-lg btn-primary" id="save">Save</button>
</form>

<script>
  require(['../../plugins/nodebb-plugin-shortcuts/services/admin/AdminSettings.js'],function(conf){conf()});
</script>