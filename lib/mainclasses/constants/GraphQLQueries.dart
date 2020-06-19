class GraphQLQueries {
  // Все инспекции по айди проекта
  String inspectionRequestsFromProjectId(rowIdOfProject) {
    return """
query findAllInspectionRequests {
  allInspectionRequests(filters:{projectIdEq:$rowIdOfProject}){
    id
    comment
    constructive
    managerId
    projectId
    constructiveId
    planDate
    manager{
      name
    }
    project{
      id
      name
    }
    rowId
  }
}
""";
  }

  String inspectionRequests() {
    return """
query findAllInspectionRequests {
  allInspectionRequests{
    id
    comment
    constructive
    managerId
    projectId
    constructiveId
    planDate
    manager{
      name
    }
    project{
      id
      name
    }
    rowId
  }
}
""";
  }

  // Все проекты
  String projectList() {
    return """
query projectsList {
  allProjects{
    name
    longitude
    latitude
    dateBegin
    dateComplete
    wasChanged
    timeZoneOffset
    outsideId
    repoId
    shortName
    cost
    actualProjectTransactionId
    characteristics
    rowId
  }
}
  """;
  }

  // Все конструктивы
  String constructiveList() {
    return """
query constructives {
  allConstructives{
    id
    name
    code
    measureUnitId
    parentElementId
    projectId
    elementType
    isComplete
    constructiveTypeId
    rowId
  }
}
    """;
  }

  // Все инциденты
  String incidentList(){
    return """
query findIncidents {
  allIncidents{
    id
    comment
    constructive
    managerId
    projectId
    constructiveId
    work
    descritpion
    deleted
    stopWorkUntil
    resolveUntil
    recommendation
    resolved
    category
    manager{
      id
      name
      participationBegin
      participationFinish
      projectId
      role
      rowId
    }
    rowId
  }
}
    """;
  }

  String incidentListFromProjectId(rowIdOfProject){
    return """
query findIncidentsFromProjectId {
  allIncidents(filters: {projectIdEq: $rowIdOfProject}){
    id
    comment
    constructive
    managerId
    projectId
    constructiveId
    work
    descritpion
    deleted
    stopWorkUntil
    resolveUntil
    recommendation
    resolved
    category
    manager{
      id
      name
      participationBegin
      participationFinish
      role
      rowId
    }
    rowId
  }
}
    """;
  }
}
