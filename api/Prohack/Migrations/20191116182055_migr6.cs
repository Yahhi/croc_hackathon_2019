using Microsoft.EntityFrameworkCore.Migrations;

namespace Prohack.Migrations
{
    public partial class migr6 : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "DeviceId",
                table: "Turbines",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.CreateIndex(
                name: "IX_Turbines_DeviceId",
                table: "Turbines",
                column: "DeviceId");

            migrationBuilder.AddForeignKey(
                name: "FK_Turbines_Devices_DeviceId",
                table: "Turbines",
                column: "DeviceId",
                principalTable: "Devices",
                principalColumn: "Id",
                onDelete: ReferentialAction.NoAction);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Turbines_Devices_DeviceId",
                table: "Turbines");

            migrationBuilder.DropIndex(
                name: "IX_Turbines_DeviceId",
                table: "Turbines");

            migrationBuilder.DropColumn(
                name: "DeviceId",
                table: "Turbines");
        }
    }
}
