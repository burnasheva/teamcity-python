<%@ taglib prefix="props" tagdir="/WEB-INF/tags/props" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="forms" tagdir="/WEB-INF/tags/forms" %>
<%@ taglib prefix="l" tagdir="/WEB-INF/tags/layout" %>

<jsp:useBean id="bean" class="jetbrains.buildServer.python.server.PythonPropertiesBean"/>

<script type="text/javascript" src="${teamcityPluginResourcesPath}js/pythonconf.js"></script>


<script type="text/javascript">

  BS.Python =
  {
      refreshControlsState: function()
      {
          var kindSelector = $j("#python-kind");
          var verSelector = $j("#python-ver");
          var bitnessSelector = $j("#bitness");
          var exeField = $j("#python-exe");

          var kind = kindSelector.attr("value");

          if (kind == 'C') verSelector.show();
          else             verSelector.hide();

          if (kind == 'X' || kind == '*') { bitnessSelector.attr("value","*"); bitnessSelector.attr("disabled","disabled"); }
          else bitnessSelector.removeAttr("disabled");

          if (kind == 'X') exeField.removeAttr("disabled");
          else exeField.attr("disabled","disabled");

          this.refreshExeField();
      },


      refreshExeField: function()
      {
          var kindSelector = $j("#python-kind");
          var verSelector = $j("#python-ver");
          var bitnessSelector = $j("#bitness");
          var exeField = $j("#python-exe");

          var kind = kindSelector.attr("value");

          var exeString = exeField.attr("value");
          var bitnessCode = bitnessSelector.attr("value");
          var bitnessString = bitnessCode == '*' ? '' : '.x' + bitnessCode;
          switch (kind)
          {
              case '*':
                  exeString = "%AnyPython%";
                  break;
              case 'C':
                  var ver = verSelector.attr("value");
                  exeString = "%Python" + (ver == '*' ? '' : '.'+ver) + bitnessString + "%";
                  break;
              case 'I':
                  exeString = "%IronPython" + bitnessString + "%";
                  break;
              case 'J':
                  exeString = "%Jython%";
                  break;
          }
          exeField.attr("value", exeString);
      },


      updateScriptMode : function()
      {
        var val = $('python_script_mode').value;
        if (val == 'file')
        {
            BS.Util.hide($('python_script_code'));
            BS.Util.show($('python_script_file'));
        }
        if (val == 'code')
        {
            BS.Util.hide($('python_script_file'));
            BS.Util.show($('python_script_code'));
        }
        BS.MultilineProperties.updateVisible();
      }
  };

</script>




<tr>
    <th>
        <label for="python-kind">Python kind</label>
    </th>
    <td>
        <props:selectProperty name="python-kind" onchange="BS.Python.refreshControlsState()">
            <props:option value="*">any</props:option>
            <props:option value="C">Classic Python</props:option>
            <props:option value="I">Iron Python</props:option>
            <props:option value="J">Jython</props:option>
            <props:option value="X">Custom</props:option>
        </props:selectProperty>
        <props:selectProperty name="python-ver" onchange="BS.Python.refreshExeField()">
            <props:option value="*">any</props:option>
            <props:option value="2">2.x</props:option>
            <props:option value="3">3.x</props:option>
        </props:selectProperty>
    </td>
</tr>


<tr>
    <th>
        <label for="bitness">Bitness</label>
    </th>
    <td>
        <props:selectProperty name="bitness" onchange="BS.Python.refreshExeField()">
            <props:option value="*">any</props:option>
            <props:option value="32">x32</props:option>
            <props:option value="64">x64</props:option>
        </props:selectProperty>
    </td>
</tr>


<tr>
    <th>
        <label for="python-exe">Python executable</label>
    </th>
    <td>
        <props:textProperty name="python-exe" className="longField" />
        <span class="smallNote">Path to Python executable</span>
    </td>
</tr>


<forms:workingDirectory/>


<tr>
  <th>Script:</th>
  <td>
    <props:selectProperty name="python-script-mode" id="python_script_mode" className="longField" onchange="BS.Python.updateScriptMode()">
      <props:option value="file">File</props:option>
      <props:option value="code">Source code</props:option>
    </props:selectProperty>
    <span class="error" id="error_script_mode"></span>
  </td>
</tr>

<tr id="python_script_file">
  <th><label for="python-script-file-name">Python file:</label></th>
  <td>
    <props:textProperty name="python-script-file-name" className="longField"/>
    <span class="smallNote">Enter Python file path relative to checkout directory</span>
    <span class="error" id="error_script_file_name"></span>
  </td>
</tr>

<tr id="python_script_code">
  <th><label for="python-script-code">Python script source:</label></th>
  <td>
    <props:multilineProperty name="python-script-code"
                             linkTitle="Enter Python script content"
                             cols="60" rows="15"
                             expanded="${true}"/>
    <span class="smallNote">Enter Python script. TeamCity references will be replaced in the code</span>
    <span class="error" id="error_python_script_code"></span>
  </td>
</tr>

<tr id="python_path">
  <th>
    <label for="python-path">Path to modules (the <tt>PYTHONPATH</tt> or <tt>IRONPYTHONPATH</tt> variable)</label>
  </th>
  <td>
    <props:textProperty name="python-path" className="longField" />
  </td>
</tr>


<script type="text/javascript">

  BS.Python.refreshControlsState();
  BS.Python.updateScriptMode();

</script>




