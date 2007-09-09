<#--
Licensed to the Apache Software Foundation (ASF) under one
or more contributor license agreements.  See the NOTICE file
distributed with this work for additional information
regarding copyright ownership.  The ASF licenses this file
to you under the Apache License, Version 2.0 (the
"License"); you may not use this file except in compliance
with the License.  You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing,
software distributed under the License is distributed on an
"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
KIND, either express or implied.  See the License for the
specific language governing permissions and limitations
under the License.
-->

<div class="screenlet">
  <div class="screenlet-title-bar">
    <ul>
      <#if project?has_content>
        <li class="head3">&nbsp;${uiLabelMap.PageTitleEditProject}&nbsp;#${project.workEffortName?if_exists} ${uiLabelMap.CommonInformation}</li>
      <#else>
        <li class="head3">&nbsp;${uiLabelMap.PageTitleAddProject}</li>
      </#if>
    </ul>
    <br class="clear" />
  </div> 
  <div class="screenlet-body">    
    <#if project?has_content>
        <a href="<@ofbizUrl>EditProject?DONE_PAGE=${donePage}</@ofbizUrl>"></a>
        <form name="editProjectForm" action="<@ofbizUrl>updateProject</@ofbizUrl>">
    <#else>
        <form name="editProjectForm" action="<@ofbizUrl>createProject</@ofbizUrl>">
    </#if>
        <table width="100%" cellpadding="2" cellspacing="0" border="0">
          <#if !(project?exists)>
            <tr>
              <td><input type="hidden" name="workEffortTypeId" value="${parameters.workEffortTypeId?if_exists}"/></td>
          <#else>
              <td><input type="hidden" name="workEffortTypeId" value="${project.workEffortTypeId?if_exists}"/></td>
              <td><input type="hidden" name="workEffortId" value="${project.workEffortId?if_exists}"/></td>
              <td><input type="hidden" name="workEffortName" value="${project.workEffortName?if_exists}"/></td> 
          </#if>
          </tr>
          <#if project?exists>
            <tr>    
              <td class="label" >${uiLabelMap.ProjectMgrWorkEffortId}</td>    
              <td>${project.workEffortId?if_exists}<span class="tooltip">${uiLabelMap.CommonNotModifRecreat}</span></td>    
            </tr>
            <tr>    
              <td class="label" >${uiLabelMap.CommonName}</td>
              <td>${project.workEffortName?if_exists}<span class="tooltip">${uiLabelMap.CommonNotModifRecreat}</span></td>
            </tr>
            <tr>    
              <td class="label" >${uiLabelMap.CommonDescription}</td>
              <td><input type="text" name="description" value="${project.description?if_exists}"/></td>
            </tr>
            <tr>    
              <td class="label" >${uiLabelMap.CommonStatus}</td>
              <td>    
                <select name="currentStatusId" class="selectBox">
                  <#assign currentStatusId = project.currentStatusId?if_exists>
                  <#assign statusValidChangeToDetailList = delegator.findByAnd("StatusValidChangeToDetail", Static["org.ofbiz.base.util.UtilMisc"].toMap("statusId", currentStatusId))>
                    <option SELECTED value="${currentStatusId}">${currentStatusId}</option>  
                    <option>--</option>
                  <#list statusValidChangeToDetailList as statusValidChangeToDetail>
                    <option value=${statusValidChangeToDetail.statusId}>[${uiLabelMap.WorkEffortGeneral}]${statusValidChangeToDetail.description}</option>
                  </#list>
                </select>
              </td>  
            </tr>
            <tr>
              <td class="label">${uiLabelMap.CommonPriority}</td>
              <#if project?has_content>
                <#assign priority = project.priority?if_exists>      
              </#if>
              <td>
                <select name="priority" class="selectBox" size="1">
                  <option SELECTED value="${priority}">${priority}</option>       
                  <option></option>
                  <option value=1>1 (${uiLabelMap.WorkEffortPriorityHigh})</option>
                  <option value=2>2</option>
                  <option value=3>3</option>
                  <option value=4>4</option>
                  <option value=5>5</option>
                  <option value=6>6</option>
                  <option value=7>7</option>
                  <option value=8>8</option>
                  <option value=9>9 (${uiLabelMap.WorkEffortPriorityLow})</option>
                </select>
              </td>
            </tr>
            <tr>
              <td class="label">${uiLabelMap.ProjectMgrWorkEffortScopeEnumId}</td>
              <td>             
                <select name="scopeEnumId" class="selectBox">
                  <#assign enumerations = delegator.findByAnd("Enumeration", Static["org.ofbiz.base.util.UtilMisc"].toMap("enumTypeId", "WORK_EFF_SCOPE"))>
                  <#assign scopeEnumId = project.scopeEnumId?if_exists>            
                  <#list enumerations as enumeration>                    
                    <option <#if "${enumeration.enumId}" == scopeEnumId?if_exists>selected="selected"</#if>>${enumeration.description}</option>
                  </#list>
                </select>
              </td>
            </tr>
            <tr>
              <td class="label">${uiLabelMap.WorkEffortEstimatedStartDate}</td>
              <td>
                <input type="text" name="estimatedStartDate" value="${project.estimatedStartDate?if_exists}"/>
                <a href="javascript:call_cal(document.editProjectForm.estimatedStartDate,'${nowTimestamp?string}');"><img src="<@ofbizContentUrl>/images/cal.gif</@ofbizContentUrl>" width="16" height="16" border="0" alt="Calendar"/></a>
              </td>  
            </tr>
            <tr>
              <td class="label">${uiLabelMap.WorkEffortEstimatedCompletionDate}</td>
              <td>
                <input type="text" name="estimatedCompletionDate" value="${project.estimatedCompletionDate?if_exists}"/>
                <a href="javascript:call_cal(document.editProjectForm.estimatedCompletionDate,'${nowTimestamp?string}');"><img src="<@ofbizContentUrl>/images/cal.gif</@ofbizContentUrl>" width="16" height="16" border="0" alt="Calendar"/></a>
              </td>
            </tr>
            <tr>
              <td class="label">${uiLabelMap.FormFieldTitle_actualStartDate}</td>
              <td>
                <input type="text" name="actualStartDate" value="${project.actualStartDate?if_exists}"/>
                <a href="javascript:call_cal(document.editProjectForm.actualStartDate,'${nowTimestamp?string}');"><img src="<@ofbizContentUrl>/images/cal.gif</@ofbizContentUrl>" width="16" height="16" border="0" alt="Calendar"/></a>
              </td>
            </tr>  
            <tr>
              <td class="label">${uiLabelMap.FormFieldTitle_actualCompletionDate}</td>
              <td>
                <input type="text" name="actualCompletionDate" value="${project.actualCompletionDate?if_exists}"/>
                <a href="javascript:call_cal(document.editProjectForm.actualCompletionDate,'${nowTimestamp?string}');"><img src="<@ofbizContentUrl>/images/cal.gif</@ofbizContentUrl>" width="16" height="16" border="0" alt="Calendar"/></a>
              </td>
            </tr>  
          <#else>
            <tr>    
              <td class="label" >${uiLabelMap.CommonName}*</td>
              <td><input type="text" name="workEffortName" value=""/><span class="tooltip">${uiLabelMap.CommonRequired}</span></td>
            </tr>
            <tr>    
              <td class="label" >${uiLabelMap.CommonDescription}</td>
              <td><input type="text" name="description" value=""/></td>
            </tr>
            <tr>    
              <td class="label" >${uiLabelMap.CommonStatus}</td>
              <td>    
                <select name="currentStatusId" class="selectBox">
                  <#assign statusItemGenrals = delegator.findByAnd("StatusItem", Static["org.ofbiz.base.util.UtilMisc"].toMap("statusTypeId", "CALENDAR_STATUS"))>
                  <#assign statusItemTasks = delegator.findByAnd("StatusItem", Static["org.ofbiz.base.util.UtilMisc"].toMap("statusTypeId", "TASK_STATUS"))>
                  <#assign statusItemEvents = delegator.findByAnd("StatusItem", Static["org.ofbiz.base.util.UtilMisc"].toMap("statusTypeId", "EVENT_STATUS"))>
                  <#list statusItemGenrals as statusItem> 
                    <option value="${statusItem.statusId?if_exists}">[${uiLabelMap.WorkEffortGeneral}]${statusItem.description}</option>
                  </#list>                
                  <#list statusItemTasks as statusItem>
                    <option value="${statusItem.statusId?if_exists}">[${uiLabelMap.WorkEffortTask}]${statusItem.description}</option>
                  </#list>                
                  <#list statusItemEvents as statusItem>
                    <option value="${statusItem.statusId?if_exists}">[${uiLabelMap.WorkEffortEvent}]${statusItem.description}</option>
                  </#list>
                </select>
              </td>
            </tr>
            <tr>
              <td class="label">${uiLabelMap.CommonPriority}</td>
              <#if project?has_content>
                <#assign priority = project.priority?if_exists>      
               </#if>
              <td>
                <select name="priority" class="selectBox" size="1">
                  <option></option>
                  <option value=1>1 (${uiLabelMap.WorkEffortPriorityHigh})</option>
                  <option value=2>2</option>
                  <option value=3>3</option>
                  <option value=4>4</option>
                  <option value=5>5</option>
                  <option value=6>6</option>
                  <option value=7>7</option>
                  <option value=8>8</option>
                  <option value=9>9 (${uiLabelMap.WorkEffortPriorityLow})</option>
                </select>
              </td>
            </tr>
            <tr>
              <td class="label">${uiLabelMap.ProjectMgrWorkEffortScopeEnumId}</td>
              <td>
                <select name="scopeEnumId" class="selectBox">
                  <#assign enumerations = delegator.findByAnd("Enumeration", Static["org.ofbiz.base.util.UtilMisc"].toMap("enumTypeId", "WORK_EFF_SCOPE"))>
                  <#list enumerations as enumeration>                    
                    <option value="${enumeration.enumId}">${enumeration.description}</option>
                  </#list>  
                </select>
              </td>  
            </tr>
            <tr>
              <td class="label">${uiLabelMap.WorkEffortEstimatedStartDate}</td>
              <td>
                <input type="text" name="estimatedStartDate" value=""/>
                <a href="javascript:call_cal(document.editProjectForm.estimatedStartDate,'${nowTimestamp?string}');"><img src="<@ofbizContentUrl>/images/cal.gif</@ofbizContentUrl>" width="16" height="16" border="0" alt="Calendar"/></a>  
              </td>
            </tr>
            <tr>
              <td class="label">${uiLabelMap.WorkEffortEstimatedCompletionDate}</td>
              <td>
                <input type="text" name="estimatedCompletionDate" value=""/>
                <a href="javascript:call_cal(document.editProjectForm.estimatedCompletionDate,'${nowTimestamp?string}');"><img src="<@ofbizContentUrl>/images/cal.gif</@ofbizContentUrl>" width="16" height="16" border="0" alt="Calendar"/></a>
              </td> 
            </tr>
            <tr>
              <td class="label">${uiLabelMap.FormFieldTitle_actualStartDate}</td>
              <td>
                <input type="text" name="actualStartDate" value=""/>
                <a href="javascript:call_cal(document.editProjectForm.actualStartDate,'${nowTimestamp?string}');"><img src="<@ofbizContentUrl>/images/cal.gif</@ofbizContentUrl>" width="16" height="16" border="0" alt="Calendar"/></a>
              </td>
            </tr>
            <tr>
              <td class="label">${uiLabelMap.FormFieldTitle_actualCompletionDate}</td>
              <td>
                <input type="text" name="actualCompletionDate" value=""/>
                <a href="javascript:call_cal(document.editProjectForm.actualCompletionDate,'${nowTimestamp?string}');"><img src="<@ofbizContentUrl>/images/cal.gif</@ofbizContentUrl>" width="16" height="16" border="0" alt="Calendar"/></a>
              </td> 
            </tr>   
          </#if>   
          <tr>
            <td>&nbsp;</td>    
            <td>
              <input type="submit" name="submit" value="${uiLabelMap.CommonSave}"/>
            </td>
          </tr>    
        </table>
      </form>
  </div>
</div>
