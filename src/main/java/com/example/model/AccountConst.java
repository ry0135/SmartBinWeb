package com.example.model;

public final class AccountConst {
    private AccountConst() {}

    // Role mapping mới
    public static final class Roles {
        public static final int ADMIN   = 1;
        public static final int MANAGER = 2;
        public static final int WORKER  = 3;
        public static final int USER    = 4;
        private Roles() {}
    }

    // Status
    public static final class Status {
        public static final int ACTIVE = 1;
        public static final int BANNED = 0;
        private Status() {}
    }
}
