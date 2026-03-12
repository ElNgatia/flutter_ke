// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supabase_client_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(supabaseClient)
final supabaseClientProvider = SupabaseClientProvider._();

final class SupabaseClientProvider
    extends
        $FunctionalProvider<
          AsyncValue<SupabaseClient>,
          SupabaseClient,
          FutureOr<SupabaseClient>
        >
    with $FutureModifier<SupabaseClient>, $FutureProvider<SupabaseClient> {
  SupabaseClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'supabaseClientProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$supabaseClientHash();

  @$internal
  @override
  $FutureProviderElement<SupabaseClient> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SupabaseClient> create(Ref ref) {
    return supabaseClient(ref);
  }
}

String _$supabaseClientHash() => r'9b4b67ce2e3a19eea3a162c66a4d7a5ea6c05ec7';
