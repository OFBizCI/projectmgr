/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 * 
 * http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

import java.util.*;
import java.lang.*;
import org.ofbiz.entity.*;
import org.ofbiz.base.util.*;
import org.ofbiz.entity.util.*;

projectId = parameters.projectId;
userLogin = parameters.userLogin;

//project info
result = dispatcher.runSync("getProject", [projectId : projectId, userLogin : userLogin]);
project = result.projectInfo;
if (project && project.startDate) 
    context.chartStart = project.startDate;
else
    context.chartStart = UtilDateTime.nowTimestamp(); // default todays date
if (project && project.completionDate)         
    context.chartEnd = project.completionDate;
else
    context.chartEnd = UtilDateTime.addDaysToTimestamp(UtilDateTime.nowTimestamp(), 14); // default 14 days long

if (project == null) return;

ganttList = new LinkedList();
result = dispatcher.runSync("getProjectPhaseList", [userLogin : userLogin , projectId : projectId]);
phases = result.phaseList;
if (phases){
    phases.each { phase ->
        newPhase = phase;
        newPhase.phaseNr = phase.phaseId;
        if (!newPhase.estimatedStartDate && newPhase.actualStartDate) {
            newPhase.estimatedStartDate = newPhase.actualStartDate;
        }
        if (!newPhase.estimatedStartDate) {
            newPhase.estimatedStartDate = context.chartStart;
        }
        if (!newPhase.estimatedCompletionDate && newPhase.actualCompletionDate) {
            newPhase.estimatedCompletionDate = newPhase.actualCompletionDateDate;
        }
        if (!newPhase.estimatedCompletionDate) {
            newPhase.estimatedCompletionDate = UtilDateTime.addDaysToTimestamp(newPhase.estimatedStartDate, 3);
        }
        newPhase.workEffortTypeId = "PHASE";
        ganttList.add(newPhase);
        tasks = delegator.findByAnd("WorkEffort", ["workEffortParentId" : phase.phaseId], ["workEffortName"]);
        if (tasks){
            tasks.each { task ->
                resultTaskInfo = dispatcher.runSync("getProjectTask", [userLogin : userLogin , taskId : task.workEffortId]);
                taskInfo = resultTaskInfo.taskInfo;
                taskInfo.taskNr = task.workEffortId;
                taskInfo.phaseNr = phase.phaseId;
                if (!taskInfo.estimatedStartDate && taskInfo.actualStartDate) {
                    taskInfo.estimatedStartDate = taskInfo.actualStartDate;
                }
                if (!taskInfo.estimatedStartDate) {
                    taskInfo.estimatedStartDate = newPhase.estimatedStartDate;
                }
                if (!taskInfo.estimatedCompletionDate && taskInfo.actualCompletionDate) {
                    taskInfo.estimatedCompletionDate = taskInfo.actualCompletionDate;
                }
                if (!taskInfo.estimatedCompletionDate) {
                    taskInfo.estimatedCompletionDate = UtilDateTime.addDaysToTimestamp(newPhase.estimatedStartDate, 3);
                }
                taskInfo.estimatedStartDate = UtilDateTime.toDateString(taskInfo.estimatedStartDate, "MM/dd/yyyy");
                taskInfo.estimatedCompletionDate = UtilDateTime.toDateString(taskInfo.estimatedCompletionDate, "MM/dd/yyyy");
                taskInfo.workEffortTypeId = "TASK";
                if (taskInfo.currentStatusId == "PTS_COMPLETED") {
                    taskInfo.completion = 100;
                }else{
                    taskInfo.completion = 0;
                }
                taskInfo.url = "/projectmgr/control/taskView?workEffortId="+task.workEffortId;
                resultTaskResource = dispatcher.runSync("getTasksByParties", [userLogin : userLogin , workEffortId : task.workEffortId]);
                taskParties = resultTaskResource.taskParties;
                resource = "";
                int i = 0;
                if (taskParties){
                    taskParties.each { parties ->
                        symbol = " ";
                        partyname = parties.partyName;
                        name = partyname.substring(partyname.indexOf(",")+1 , partyname.length());
                        if (i > 0){
                            symbol = ", ";
                        }
                        resource =  resource + symbol + name;
                        i++;    
                    }
                }
                taskInfo.resource = resource ; 
                
                // dependency
                preTasks = delegator.findByAnd("WorkEffortAssoc", ["workEffortIdTo" : task.workEffortId], ["workEffortIdFrom"]);
                if (preTasks) {
                    taskInfo.preDecessor = preTasks[0].workEffortIdFrom;
                }
                ganttList.add(taskInfo);
            }
        }
    }
}
context.phaseTaskList = ganttList;

