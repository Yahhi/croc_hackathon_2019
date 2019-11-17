using Microsoft.EntityFrameworkCore.Migrations;

namespace Prohack.Migrations
{
    public partial class migr7 : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Datas_Devices_DeviceId",
                table: "Datas");

            migrationBuilder.DropForeignKey(
                name: "FK_Devices_Mines_MineId",
                table: "Devices");

            migrationBuilder.DropForeignKey(
                name: "FK_Turbines_Devices_DeviceId",
                table: "Turbines");

            migrationBuilder.DropForeignKey(
                name: "FK_Turbines_Mines_MineId",
                table: "Turbines");

            migrationBuilder.AlterColumn<int>(
                name: "DeviceId",
                table: "Turbines",
                nullable: true,
                oldClrType: typeof(int),
                oldType: "int");

            migrationBuilder.AddForeignKey(
                name: "FK_Datas_Devices_DeviceId",
                table: "Datas",
                column: "DeviceId",
                principalTable: "Devices",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_Devices_Mines_MineId",
                table: "Devices",
                column: "MineId",
                principalTable: "Mines",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_Turbines_Devices_DeviceId",
                table: "Turbines",
                column: "DeviceId",
                principalTable: "Devices",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_Turbines_Mines_MineId",
                table: "Turbines",
                column: "MineId",
                principalTable: "Mines",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Datas_Devices_DeviceId",
                table: "Datas");

            migrationBuilder.DropForeignKey(
                name: "FK_Devices_Mines_MineId",
                table: "Devices");

            migrationBuilder.DropForeignKey(
                name: "FK_Turbines_Devices_DeviceId",
                table: "Turbines");

            migrationBuilder.DropForeignKey(
                name: "FK_Turbines_Mines_MineId",
                table: "Turbines");

            migrationBuilder.AlterColumn<int>(
                name: "DeviceId",
                table: "Turbines",
                type: "int",
                nullable: false,
                oldClrType: typeof(int),
                oldNullable: true);

            migrationBuilder.AddForeignKey(
                name: "FK_Datas_Devices_DeviceId",
                table: "Datas",
                column: "DeviceId",
                principalTable: "Devices",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_Devices_Mines_MineId",
                table: "Devices",
                column: "MineId",
                principalTable: "Mines",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_Turbines_Devices_DeviceId",
                table: "Turbines",
                column: "DeviceId",
                principalTable: "Devices",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_Turbines_Mines_MineId",
                table: "Turbines",
                column: "MineId",
                principalTable: "Mines",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
