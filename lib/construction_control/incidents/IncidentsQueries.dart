String allInspectionRequestId(rowIdOfProject){
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