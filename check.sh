
#!/usr/bin/env bash

overall_status=0

for n in 1 2 3 4; do
    input_dir="Testcase${n}"
    output_dir="Testcase${n}Diff"

    correct=1
    has_differences=0

    for file1 in "$input_dir"/*.1.txt; do
        [ -f "$file1" ] || continue

        file2="${file1%.1.txt}.2.txt"
        [ -f "$file2" ] || continue

        filename="${file1##*/}"
        basename="${filename%.1.txt}"
        output_file="$output_dir/${basename}Diff.txt"

        if ! cmp -s "$file1" "$file2"; then
            has_differences=1

            if [ ! -f "$output_file" ]; then
                correct=0
            elif ! cmp -s \
                <(diff -u "$file1" "$file2" | tail -n +3) \
                <(tail -n +3 "$output_file"); then
                correct=0
            fi
        else
            if [ -e "$output_file" ]; then
                correct=0
            fi
        fi
    done

    if [ "$has_differences" -eq 1 ]; then
        if [ ! -d "$output_dir" ]; then
            correct=0
        fi
    else
        if [ -e "$output_dir" ]; then
            correct=0
        fi
    fi

    if [ -d "$output_dir" ]; then
        for output_file in "$output_dir"/*; do
            [ -e "$output_file" ] || continue

            if [ ! -f "$output_file" ]; then
                correct=0
                continue
            fi

            filename="${output_file##*/}"

            case "$filename" in
                *Diff.txt)
                    basename="${filename%Diff.txt}"
                    file1="$input_dir/${basename}.1.txt"
                    file2="$input_dir/${basename}.2.txt"

                    if [ ! -f "$file1" ] || [ ! -f "$file2" ]; then
                        correct=0
                    elif cmp -s "$file1" "$file2"; then
                        correct=0
                    fi
                    ;;
                *)
                    correct=0
                    ;;
            esac
        done
    fi

    if [ "$correct" -eq 1 ]; then
        echo "Testcase${n}: PASS"
    else
        echo "Testcase${n}: FAIL"
        overall_status=1
    fi
done

exit "$overall_status"
