class CategoriesManager {
    constructor() {
        this.Db = require("../../DAL/MSSQL/MssqlConnection.js");
    }

    async GetCategoriesByOrganization(organizationId)
    {
        let res = await this.Db.ExecuteStoredPorcedure("GetCategoriesByOrganization",{OrganizationId:organizationId});
        return res.recordsets[0];
    }

}
module.exports = CategoriesManager;