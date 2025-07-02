public class EddyUtils {
    public static int compare_versions (string v1, string v2) {
        // https://www.debian.org/doc/debian-policy/ch-controlfields.html#version

        string a = v1;
        string b = v2;

        // check for empty strings - later we split the strings and it would break on an empty array
        if (a == "")
            return -1;
        if (b == "")
            return 1;

        // check epochs
        string[] atok = a.split(":");
        string[] btok = b.split(":");

        int a_epoch, b_epoch;
        if (atok.length >= 2 ) {
            bool a_is_epoch = int.try_parse(atok[0], out a_epoch);

            if(!a_is_epoch)
                a_epoch = 0;
        } else {
            a_epoch = 0;
        }

        if (btok.length >= 2) {
            bool b_is_epoch = int.try_parse(btok[0], out b_epoch);

            if(!b_is_epoch)
                b_epoch = 0;
        } else {
             b_epoch = 0;
        }

        if (a_epoch != b_epoch)
            return a_epoch - b_epoch;

        // trim epochs when the same (including assumed 0 when none)
        a = join_sliced_from_1(atok);
        b = join_sliced_from_1(btok);

        //check upstream version
        Regex regex = new Regex("[+~-]");
        atok = regex.split(a);
        btok = regex.split(b);

        string[] aparts = atok[0].split (".");
        string[] bparts = btok[0].split (".");

        int length = int.min (aparts.length, bparts.length);
        for (int i = 0; i < length; i++) {
            int a_num, b_num;
            bool a_is_num = int.try_parse(aparts[i], out a_num);
            bool b_is_num = int.try_parse(bparts[i], out b_num);

            if (a_is_num && b_is_num) {
                int diff = a_num - b_num;
                if (diff != 0) {
                    return diff;
                }
            } else {
                int rc = strcmp (aparts[i], bparts[i]);
                if (rc != 0) {
                     return rc;
                }
            }
            if (i == length - 1) {
                if(aparts.length != bparts.length) {
                    return aparts.length - bparts.length;
                }
            }
        }

        // a tilde sorts before anything, even the end of a part
        atok = a.split ("~");
        btok = b.split ("~");

        if (atok.length < 2 && btok.length >= 2) {
            return 1;
        } else if (atok.length >= 2 && btok.length < 2) {
            return -1;
        }

        // check debian revision if present
        atok = a.split("-");
        btok = b.split("-");

        int a_dr, b_dr;
        bool a_dr_is_num = int.try_parse(atok[atok.length - 1], out a_dr);
        bool b_dr_is_num = int.try_parse(btok[btok.length - 1], out b_dr);

        if (a_dr_is_num && b_dr_is_num) {
            if (a_dr != b_dr)
                return a_dr - b_dr;
        }

        return strcmp(a, b);
    }

    private static string join_sliced_from_1(string[] arr) {
        if (arr.length == 0)
            return "";

        if (arr.length == 1)
            return arr[0];

        string result = "";
        for (int i = 1; i < arr.length; i++) {
            result += arr[i];
        }

        return result;
    }
}