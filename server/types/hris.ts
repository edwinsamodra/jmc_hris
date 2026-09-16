export interface Employee {
  id: number;
  employeeNumber: string;
  name: string;
  email: string;
  position: string;
  departmentId: number;
  employmentStatus: "Tetap" | "Kontrak" | "Magang";
  joinDate: string;
}

export interface Department {
  id: number;
  name: string;
  manager: string;
}

export interface Attendance {
  id: number;
  employeeId: number;
  date: string;
  checkIn: string | null;
  checkOut: string | null;
  status: "Hadir" | "Izin" | "Sakit" | "Cuti";
}

