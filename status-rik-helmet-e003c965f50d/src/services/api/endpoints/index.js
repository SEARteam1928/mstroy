import * as access_rules from './access_rules';
import * as auth from './auth';
import * as bim from './bim';
import * as database_procedure from './database_procedure';
import * as devicecoordinates from './devicecoordinates';
import * as devices from './devices';
import * as entities from './entities';
import * as excel from './excel';
import * as files from './files';
import * as groups from './groups';
import * as objects from './objects';
import * as projects from './projects';
import * as reports from './reports';
import * as roles from './roles';
import * as spider from './spider';
import * as time_resource from './time_resource';
import * as users from './users';
import * as work_analyze from './work_analyze';
import * as work_sessions from './work_sessions';
import * as workers from './workers';

export default {
    ...access_rules,
    ...auth,
    ...bim,
    ...database_procedure,
    ...devicecoordinates,
    ...devices,
    ...entities,
    ...excel,
    ...files,
    ...groups,
    ...objects,
    ...projects,
    ...reports,
    ...roles,
    ...spider,
    ...time_resource,
    ...users,
    ...work_analyze,
    ...work_sessions,
    ...workers
};
