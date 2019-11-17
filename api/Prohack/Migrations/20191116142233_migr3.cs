using Microsoft.EntityFrameworkCore.Migrations;

namespace Prohack.Migrations
{
    public partial class migr3 : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Data_Devices_DeviceId",
                table: "Data");

            migrationBuilder.DropPrimaryKey(
                name: "PK_Data",
                table: "Data");

            migrationBuilder.RenameTable(
                name: "Data",
                newName: "Datas");

            migrationBuilder.RenameIndex(
                name: "IX_Data_DeviceId",
                table: "Datas",
                newName: "IX_Datas_DeviceId");

            migrationBuilder.AddPrimaryKey(
                name: "PK_Datas",
                table: "Datas",
                column: "DataId");

            migrationBuilder.AddForeignKey(
                name: "FK_Datas_Devices_DeviceId",
                table: "Datas",
                column: "DeviceId",
                principalTable: "Devices",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Datas_Devices_DeviceId",
                table: "Datas");

            migrationBuilder.DropPrimaryKey(
                name: "PK_Datas",
                table: "Datas");

            migrationBuilder.RenameTable(
                name: "Datas",
                newName: "Data");

            migrationBuilder.RenameIndex(
                name: "IX_Datas_DeviceId",
                table: "Data",
                newName: "IX_Data_DeviceId");

            migrationBuilder.AddPrimaryKey(
                name: "PK_Data",
                table: "Data",
                column: "DataId");

            migrationBuilder.AddForeignKey(
                name: "FK_Data_Devices_DeviceId",
                table: "Data",
                column: "DeviceId",
                principalTable: "Devices",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
