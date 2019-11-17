using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Prohack.Core
{
    public class TurbineLogic
    {
        public static int GetStatus(Turbine turbine)
        {
            var result = 1;
            List<Device> devices;
            var optionsBuilder = new DbContextOptionsBuilder<DatabaseContext>();
            optionsBuilder.UseSqlServer("Server=server.prohack.fun\\SQLEXPRESS;database=prohack;User ID=prohack;Password=qweqwe123;TrustServerCertificate=True");


            using (var db = new DatabaseContext(optionsBuilder.Options))
            {
                devices = db.Devices.Include(i=>i.Datas).ToList();
            }
            foreach (var device in devices)
            {
                var deviceData = DataLogic.GetSummaryForDevice(device);
                if (turbine.DeviceId != null && turbine.DeviceId == device.Id && (deviceData == null || deviceData.Date < DateTime.UtcNow.AddMinutes(-1)))
                {
                    return 100;
                }
                if (deviceData != null && deviceData.Co != null)
                {
                    if (deviceData.Co > 0 && deviceData.Co < 1)
                    {
                        result += 66;
                    }
                    if (deviceData.Co > 1)
                    {
                        result += 100;
                    }
                }
                if (deviceData != null && deviceData.Persons != null && deviceData.Persons > 0)
                {
                    result += 66;
                }
                if (deviceData != null && deviceData.Gas != null && deviceData.Gas > 2000)
                {
                    result += 33;
                }
            }
            return Math.Min(result,100);
        }
    }
}
