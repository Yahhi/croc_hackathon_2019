using Microsoft.EntityFrameworkCore;
using Prohack.Core.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Prohack.Core
{
    public class DatabaseContext : DbContext
    {
        public DbSet<Mine> Mines { get; set; }
        public DbSet<Turbine> Turbines { get; set; }
        public DbSet<Device> Devices { get; set; }
        public DbSet<Data> Datas { get; set; }
        public DatabaseContext(DbContextOptions<DatabaseContext> options)
            : base(options)
        { }
        protected override void OnModelCreating(ModelBuilder modelbuilder)
        {
            foreach (var relationship in modelbuilder.Model.GetEntityTypes().SelectMany(e => e.GetForeignKeys()))
            {
                relationship.DeleteBehavior = DeleteBehavior.Restrict;
            }

            base.OnModelCreating(modelbuilder);
        }
    }
}
