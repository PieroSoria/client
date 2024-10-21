import 'package:puntos_client/features/item/domain/models/basic_campaign_model.dart';
import 'package:puntos_client/features/item/domain/models/item_model.dart';

abstract class CampaignServiceInterface {
  Future<List<BasicCampaignModel>?> getBasicCampaignList();
  Future<BasicCampaignModel?> getCampaignDetails(String campaignID);
  Future<List<Item>?> getItemCampaignList();
}
