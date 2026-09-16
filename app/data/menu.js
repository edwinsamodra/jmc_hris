import {
  IconLayoutDashboardFilled,
  IconUserFilled,
  IconDatabaseFilled,
  IconUsers,
  IconHistory,
} from "@tabler/icons-vue";

export const menuItems = [
  {
    title: "Dashboard",
    icon: IconLayoutDashboardFilled,
    to: "/",
    moduleCode: "dashboard",
  },
  {
    title: "Data Pegawai",
    icon: IconUserFilled,
    to: "/pegawai",
    moduleCode: "employee",
  },
  {
    title: "Tunjangan",
    icon: IconDatabaseFilled,
    children: [
      {
        title: "Setting Tunjangan Transport",
        to: "/tunjangan/setting",
        moduleCode: "transport_setting",
      },
      {
        title: "Tunjangan Transport",
        to: "/tunjangan/transport",
        moduleCode: "transport_allowance",
      },
    ],
  },
  {
    title: "Manajemen User",
    icon: IconUsers,
    children: [
      {
        title: "Manajemen Role",
        to: "/user/role",
        moduleCode: "role",
      },
      {
        title: "Manajemen User",
        to: "/user/manage",
        moduleCode: "user",
      },
    ],
  },
  {
    title: "Log Aktifitas",
    icon: IconHistory,
    to: "/log",
    moduleCode: "activity_log",
  },
];
